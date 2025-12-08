    #!/bin/bash
    # Script pour résoudre l'erreur OpenPGP de Terraform
    # Erreur: Échec d’installation du fournisseur - OpenPGP : clé expirée
    
    echo "🔧 Résolution de l'erreur OpenPGP de Terraform..."
    echo "================================================"
    
    # 1. Nettoyer les caches
    echo "🧹 Étape 1: Nettoyage des caches..."
    rm -rf ~/.terraform.d/ 2>/dev/null || true
    rm -rf .terraform/ 2>/dev/null || true
    rm -f .terraform.lock.hcl 2>/dev/null || true
    
    # 2. Configurer l'environnement
    echo "⚙️  Étape 2: Configuration de l'environnement..."
    export CHECKPOINT_DISABLE=1
    export TF_PLUGIN_CACHE_DIR=""
    
    # 3. Initialiser Terraform sans le provider problématique
    echo "🔄 Étape 3: Initialisation de Terraform..."
    
    # Créer une configuration temporaire sans docker
    cat > terraform_temp.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "~> 3.5.1"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
}
EOF
    
    # Initialiser
    terraform init -upgrade -reconfigure
    
    # 4. Restaurer la configuration originale
    echo "📁 Étape 4: Restauration de la configuration..."
    rm terraform_temp.tf
    
    echo ""
    echo "✅ Solutions appliquées !"
    echo ""
    echo "📋 OPTIONS SUIVANTES :"
    echo "1. Si vous avez BESOIN du provider Docker :"
    echo "   - Utilisez une version différente dans providers.tf"
    echo "   - Exemple: version = \"~> 3.0.0\""
    echo ""
    echo "2. Si vous n'avez PAS BESOIN du provider Docker :"
    echo "   - Supprimez-le de votre configuration"
    echo "   - Votre code actuel fonctionne SANS docker"
    echo ""
    echo "3. Solution alternative :"
    echo "   terraform init -plugin-dir=\$HOME/.terraform.d/plugins/"
    echo ""
    echo "🚀 Essayez maintenant : terraform plan"
