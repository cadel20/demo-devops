# Rapport de Déploiement Docker
    
## ✅ DÉPLOIEMENT TERRAFORM + DOCKER
**Date**: 2025-12-08T10:20:25Z
**ID Projet**: b5cbad97
    
## 📊 RÉSULTATS
- ✅ Image Docker créée: `formulaire-devops`
- ✅ Conteneur lancé: `formulaire-devops`
- ✅ Port exposé: 8080 → 80
- ✅ URL: http://localhost:8080
    
## 🐳 COMMANDES DOCKER
\`\`\`bash
# Vérifier l'image
docker images formulaire-devops
    
# Vérifier le conteneur
docker ps --filter "name=formulaire-devops"
    
# Voir les logs
docker logs formulaire-devops
    
# Arrêter
docker stop formulaire-devops
    
# Shell dans le conteneur
docker exec -it formulaire-devops sh
\`\`\`
    
## 🔍 VÉRIFICATION
1. Ouvrez http://localhost:8080
2. Vérifiez avec: \`curl http://localhost:8080\`
3. Consultez les logs: \`docker logs formulaire-devops\`
    
## 📝 NOTES
- Image construite via Terraform
- Docker Desktop requis
- Nginx comme serveur web
- HTML servi depuis /usr/share/nginx/html/
    
---
*Généré automatiquement par Terraform*
