# AVANT (va échouer) :
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf      # ⬅️ SUPPRIMEZ
COPY nginx.conf /etc/nginx/conf.d/         # ⬅️ SUPPRIMEZ
COPY index.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# APRÈS (fonctionne) :
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
# Les 3 dernières lignes sont optionnelles