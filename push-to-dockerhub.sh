#!/bin/bash

# Build and push script for Docker images to Docker Hub

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}Docker Build and Push Script${NC}"
echo -e "${GREEN}=====================================${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed${NC}"
    exit 1
fi

# Prompt for Docker Hub username
read -p "Enter your Docker Hub username: " DOCKER_USERNAME

if [ -z "$DOCKER_USERNAME" ]; then
    echo -e "${RED}Error: Docker Hub username is required${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}This will:${NC}"
echo "  1. Build all Docker images"
echo "  2. Tag them with your Docker Hub username"
echo "  3. Push them to Docker Hub"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Aborted${NC}"
    exit 1
fi

# Login to Docker Hub
echo -e "${GREEN}Logging in to Docker Hub...${NC}"
docker login

# Build images
echo -e "${GREEN}Building Docker images...${NC}"
docker-compose build

# Tag images
echo -e "${GREEN}Tagging images...${NC}"
docker tag your-aws_backend $DOCKER_USERNAME/youraws-backend:latest
docker tag your-aws_frontend $DOCKER_USERNAME/youraws-frontend:latest
docker tag mysql:8.0 $DOCKER_USERNAME/youraws-mysql:latest

# Push images
echo -e "${GREEN}Pushing images to Docker Hub...${NC}"
docker push $DOCKER_USERNAME/youraws-backend:latest
docker push $DOCKER_USERNAME/youraws-frontend:latest
docker push $DOCKER_USERNAME/youraws-mysql:latest

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}Build and push completed successfully!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${YELLOW}Your Docker Hub images:${NC}"
echo "  Backend:  https://hub.docker.com/r/$DOCKER_USERNAME/youraws-backend"
echo "  Frontend: https://hub.docker.com/r/$DOCKER_USERNAME/youraws-frontend"
echo "  MySQL:    https://hub.docker.com/r/$DOCKER_USERNAME/youraws-mysql"
echo ""
echo -e "${YELLOW}Image URLs for submission:${NC}"
echo "  docker.io/$DOCKER_USERNAME/youraws-backend:latest"
echo "  docker.io/$DOCKER_USERNAME/youraws-frontend:latest"
echo "  docker.io/$DOCKER_USERNAME/youraws-mysql:latest"
echo ""
