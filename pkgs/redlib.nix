{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  cmakeMinimal,
  pkg-config,
  zstd,
}:

# TODO: Remove once nixpkgs updates redlib https://github.com/NixOS/nixpkgs/pull/520226
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redlib";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qv7vIls9BwgwDQuKEQU72J10MpaMfcLvIGfzl628eNU=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-XgHXqH4EF8TEOI+cKJ0Z2j6QYRCwGgv8bmY8gZpPN9c=";

  checkFlags = map (test: "--skip=${test}") [
    # All these test try to connect to Reddit.
    # utils.rs
    "test_fetching_subreddit_quarantined"
    "test_fetching_nsfw_subreddit"
    "test_fetching_ws"

    # client.rs
    "test_obfuscated_share_link"
    "test_share_link_strip_json"
    "test_localization_popular"
    "test_private_sub"
    "test_banned_sub"
    "test_gated_sub"
    "test_default_subscriptions"
    "test_rate_limit_check"

    # subreddit.rs
    "test_fetching_subreddit"
    "test_gated_and_quarantined"

    # user.rs
    "test_fetching_user"

    # These try to connect to the oauth client
    # oauth.rs
    "test_oauth_client"
    "test_oauth_client_refresh"
    "test_oauth_token_exists"
    "test_oauth_headers_len"
    "oauth::tests::test_generic_web_backend"
    "oauth::tests::test_mobile_spoof_backend"
  ];

  buildInputs = [ zstd.dev ];

  nativeBuildInputs = [
    gitMinimal
    cmakeMinimal
    rustPlatform.bindgenHook
    pkg-config
  ];

  meta = {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/redlib-org/redlib";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "redlib";
  };
})
