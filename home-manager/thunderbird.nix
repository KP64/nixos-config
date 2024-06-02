{

  programs.thunderbird = {
    enable = true;
    profiles.kg = {
      isDefault = true;
      settings = {
        "privacy.donottrackheader.enabled" = true;
      };
    };
  };
}
