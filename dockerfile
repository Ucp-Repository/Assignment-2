
# ==========================================
# Stage 1: Build the website using Parcel
# ==========================================
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy project source files
COPY source/ ./source/
COPY styles/ ./styles/

# Build website into dist directory
RUN npm run build


# ==========================================
# Stage 2: Serve website using Nginx
# ==========================================
FROM nginx:alpine AS production

# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy production build from builder stage
COPY --from=builder /app/dist/ /usr/share/nginx/html/

# Expose HTTP port
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
