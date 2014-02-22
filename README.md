xTable
======

xTable (prononcé crosstable) est une application web écrite avec le framework Rails 4. Elle permet de coordonner plusieurs calendriers provenant de différents groupes d'activités ou/et individus.

## Déploiement / test:

1. Installation / mise à jour des dépendances `bundle update`
2. Contrôler la présence du fichier de secret */config/initializers/secret_token.rb* : 
 * `Xtable::Application.config.secret_key_base = 'UN_SECRET'`
 * Générable avec `rake secret`
3. Configuration de la BDD MySQL dans */config/database.yml*
4. Lancer l'application `rails s`
