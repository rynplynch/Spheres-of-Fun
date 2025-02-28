# PlaneSpheres the Game

### Summary

Control a sphere as you move around a plane! More game mechanic to come.

Try the latest live web build at [www.planespheres.com](https://www.planespheres.com/)

PlaneSpheres is a Godot4 project that utilizes [nix flakes](https://wiki.nixos.org/wiki/Flakes) to generate different builds of the game, manage the development environment and build a dotnet website with the latest web build baked in.

### Roadmap

- [ ] Allow players to create and join online matches

#### Currently Supported Builds

* Linux
* nixOS
* Web


### Nix CLI

#### Running the Software

The easiest way to run the latest version of the game from the main branch is with the nix CLI.

    nix run github:rynplynch/planespheres

Using this same method you can run other software as well.

    # run a dotnet webserver that servers a web build of the game
    nix run github:rynplynch/planespheres#website

    # build a docker image of the website
    nix build github:rynplynch/planespheres#website-image

    # run a nakama service that PlaneSpheres uses for multiplayer
    nix run github:rynplynch/planespheres#nakama

#### Development
    # clone the repository
    git clone https://github.com/rynplynch/planespheres.git

    # change into the project directory
    cd planespheres

    # prepair the development enviroment
    nix develop .

    # change into game directory
    cd game

    # start the godot4 editor
    godot4 -e

    # for multiplayer to work start the nakama service
    nix run .#nakama

### Without Nix CLI

#### Running the Software

At this stage there are no downloadable packages of the game available. There is a docker image that will allow you to play the game locally via a dotnet server.

    # grab the docker image
    docker pull rynplynch/planespheres-website:1.0.0

    # create docker container
    docker run -p 8080:5000 rynplynch/planespheres-website:1.0.0

#### Development

You will have to manage the dependencies that PlaneSpheres relies on on your own. These are documented inside the *flake.nix* file at the root of the project.

    devShells.default = pkgs.mkShell {
      ...
      buildInputs = [
        # used for developing the game itself
        pkgs.godot_4
        pkgs.blender
        # used for developing the website
        pkgs.dotnetCorePackages.dotnet_9.sdk
        pkgs.dotnetCorePackages.dotnet_9.aspnetcore
      ];
      ...
    }

If you only want to run the game, all you need is the Godot4 editor and the Nakama add on found in the Godot4 asset library.

***The game will not run until you install the Nakama client code from the Godot4 asset library***

For textures to be properly applied download the materials folder from [here](https://planespheres.com/materials/plane-spheres-materials.tar.gz). Then extract and place the materials fold in the game directory.

In order to develope the multiplayer functionality follow the nakama [documentation](https://heroiclabs.com/docs/nakama/getting-started/install/docker/) to start your own nakama instance.

### Assets Used

* [Sky Box](https://polyhaven.com/a/autumn_field_puresky)

* [Concrete](https://ambientcg.com/view?id=Concrete046)

* [Anti Slip Concrete](https://polyhaven.com/a/anti_slip_concrete)

* [Rocky Terrain 02](https://polyhaven.com/a/rocky_terrain_02)
