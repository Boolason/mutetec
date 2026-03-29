# Use nginx as the base image to serve static files
FROM nginx:alpine

# Copy your website files to nginx
COPY . /usr/share/nginx/html/

# Create custom nginx config
RUN cat > /etc/nginx/conf.d/default.conf <<'EOF'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;
    
    # Enable gzip compression
    gzip on;
    gzip_types text/plain text/css text/javascript application/javascript application/json;
    
    # Cache static assets for 1 year
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Cache HTML for 2 days
    location ~* \.html$ {
        expires 2d;
        add_header Cache-Control "public";
    }
    
    # Serve index.html for all requests
    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
