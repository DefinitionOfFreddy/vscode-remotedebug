#/bin/bash

go mod tidy && go build -gcflags="all=-N -l" -o build/myApp
docker-compose up  --build