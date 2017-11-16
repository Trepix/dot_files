# Bash

## Run test environment

Build image:
```docker
    docker build -t automations . 
```

Run container:
```docker
    docker run -ti automations
```

Execute inside the container:
```sh
    sh -c "$(cat install.sh)"
```