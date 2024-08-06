start:
	@echo "Starting in go..."
	go run ./cmd
	@echo "Done!"

up:
	@echo "Starting Docker images..."
	docker compose up -d
	@echo "Docker images started!"

down:
	@echo "Stopping docker compose..."
	docker compose down
	@echo "Done!"

up_build: build
	@echo "Stopping docker images (if running...)"
	docker compose down
	@echo "Building (when required) and starting docker images..."
	docker compose up --build -d
	@echo "Docker images built and started!"

build:
	@echo "Building server binary..."
	env GOOS=linux CGO_ENABLED=0 go build -o server ./cmd
	@echo "Done!"

build_start:
	@echo "Building server binary and starting server..."
	env GOOS=linux CGO_ENABLED=0 go build -o server ./cmd
	@echo "Build Done Starting server..."
	./server

build_image:
	@echo "Building server binary and container image..."
	env GOOS=linux CGO_ENABLED=0 go build -o server ./cmd
	docker compose build
	@echo "Done!"