variable "auteur" {
  type        = string  # Remplace "chaine" par "string"
  description = "Nom de l'auteur de la configuration"
  default     = "Thaumy"
}

variable "environnement" {
  type        = string  # Remplace "chaine" par "string"
  description = "Environnement de déploiement"
  default     = "dev"
}

variable "tags" {
  type        = map(string)  # Remplace "map(chaine)" par "map(string)"
  description = "Tags à appliquer aux ressources"
  default     = {
    Owner       = "Thaumy"
    Environnement = "dev"
    Project     = "demo-devops"
  }
}