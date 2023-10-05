{ config, pkgs,  ... }: 

{
  pkgs ? import <nixpkgs> { },
  unstable-pkgs ? import <nixpkgs-unstable> { }
}: {
  environment.systemPackages = [
    unstable-pkgs.nano
  ];
}
