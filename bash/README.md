# Bash

## Run test environment

Test environment allows to test features without having to upload it to  public repository. Source folder is copied in a temporal directory like if was cloned with git, which is how production environment works.

Build image (being in /bash directory):
```docker
    docker build -t dot_files --file ./test/Dockerfile .
```

Run container:
```docker
    docker run -ti dot_files
```

Execute inside the container:
```sh
    sh -c "$(cat install.sh)"
```

## _(deprecated for now)_ Run quick test environment

Run the script:
```bash
    ./docker-quick.sh
```