# Nginx based image to serve static HTML site
FROM nginx:latest

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy website files to nginx document root
COPY . /usr/share/nginx/html

# Create a simple nginx config that works
RUN echo 'server { \
  listen 80; \
  server_name _; \
  root /usr/share/nginx/html; \
  index index.html index.htm; \
  \
  location / { \
    try_files $uri $uri/ =404; \
    add_header Cache-Control "public, max-age=3600"; \
  } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
