# youraws User Management System

Full-stack user management app for the youraws technical assessment. Includes React SPA, Express API, MySQL, Dockerized deployment, and VPS setup on Oracle Cloud.

## Technology Stack
- Frontend: React 18, React Router, Axios, Nginx
- Backend: Node.js 18, Express.js, mysql2, express-validator, helmet, cors
- Database: MySQL 8.0
- DevOps: Docker, Docker Compose, Nginx

## Live Service
- App: http://158.180.41.141
- API: http://158.180.41.141/api/users

## Docker Hub Images
- Backend: docker.io/soufianeljadi/youraws-backend:latest
- Frontend: docker.io/soufianeljadi/youraws-frontend:latest
- MySQL: docker.io/soufianeljadi/youraws-mysql:latest

## Local Development
### Prerequisites
- Docker Desktop
- Node.js 18+ (optional for non-Docker dev)

### Setup
```bash
# clone
git clone https://github.com/soufianeljadi/youraws-assessment.git
cd Your-aws

# env
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env

# run
docker-compose up --build
```
Access: http://localhost (API at http://localhost/api/users)

### Without Docker (optional)
Backend:
```bash
cd backend
npm install
npm run dev
```
Frontend:
```bash
cd frontend
npm install
npm start
```

## Production Deployment (VPS)
On the VPS (Ubuntu 22.04, Docker + Compose installed):
```bash
mkdir -p ~/youraws-app
cd ~/youraws-app

cat > docker-compose.yml <<'EOF'
version: '3.8'
services:
  mysql:
    image: ${DOCKER_USERNAME}/youraws-mysql:latest
    container_name: youraws-mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD:-root_password}
      MYSQL_DATABASE: youraws_db
      MYSQL_USER: youraws_user
      MYSQL_PASSWORD: ${DB_PASSWORD:-youraws_password}
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - youraws-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  backend:
    image: ${DOCKER_USERNAME}/youraws-backend:latest
    container_name: youraws-backend
    restart: unless-stopped
    environment:
      DB_HOST: mysql
      DB_PORT: 3306
      DB_USER: youraws_user
      DB_PASSWORD: ${DB_PASSWORD:-youraws_password}
      DB_NAME: youraws_db
      PORT: 3000
      NODE_ENV: production
      CORS_ORIGIN: "*"
    depends_on:
      mysql:
        condition: service_healthy
    networks:
      - youraws-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:3000/health"]
      timeout: 10s
      retries: 5

  frontend:
    image: ${DOCKER_USERNAME}/youraws-frontend:latest
    container_name: youraws-frontend
    restart: unless-stopped
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - youraws-network

networks:
  youraws-network:
    driver: bridge

volumes:
  mysql_data:
    driver: local
EOF

export DOCKER_USERNAME=soufianeljadi
export DB_ROOT_PASSWORD=root_password
export DB_PASSWORD=youraws_password

docker-compose pull
docker-compose up -d
```

## Security Checklist
- SSH key authentication only
- SSH restricted to your IP (OCI security list + ufw)
- Ingress: port 80 only
- DB not exposed externally
- Helmet + validation on API

## Troubleshooting
- Logs: `docker-compose logs -f`
- Service status: `docker-compose ps`
- API test: `curl http://localhost/api/users`
- DB shell: `docker-compose exec mysql mysql -uyouraws_user -p`

## Submission
- Live URL: http://158.180.41.141
- API URL: http://158.180.41.141/api/users
- GitHub: https://github.com/soufianeljadi/youraws-assessment
- Docker Hub: see images above

## Author
Soufiane El Jadi
