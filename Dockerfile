# Use nginx as the base image to serve static files
FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy your website files to nginx
COPY . /usr/share/nginx/html/

# Create custom nginx config for better caching and performance
RUN echo ' \
server { \
    listen 80; \
    server_name _; \
    root /usr/share/nginx/html; \
    index index.html; \
    \
    # Gzip compression \
    gzip on; \
    gzip_types text/plain text/css text/javascript application/javascript application/json; \
    \
    # Cache headers for static assets \
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ { \
        expires 1y; \
        add_header Cache-Control "public, immutable"; \
    } \
    \
    # Cache HTML for 2 days \
    location ~* \.html$ { \
        expires 2d; \
        add_header Cache-Control "public"; \
    } \
    \
    # Redirect to index.html for SPA routing \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
} \
' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
