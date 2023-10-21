##  Auto-issue
[TOCM]
[TOC]

### Language utilisé

YARM (yml)

-------------

### Description du projet

ajouter une action automatique dans github pour que chaque nouvelle issues soit ajouter au projet (backlog)

-------------

### Credit , participant, organisation

- Géré par l'équipe de developpement de Unionrolistes
- Liste des contributeur Credit.md 
- Licence.md

-------------
### But du projet / public cible

dans github, lorsqu'une tache arrive dans un backlog il est possible de configurer des workflow automatique pour y assigner des status, mais pas pour que chaque issue soit ajouter a celui ci.

-------------

### Installation
####  Avoir une organisation correctement configuré
##### Team
- avec des reviewer
- avec des writer
##### repository
- labels bug, documetnation, duplicate, enhancement etc
##### projects
enable projects for organisation

#####  dependency graph et bot
- security managers , add review et write
- (ce qui permetera a votre equipe de géré les soucis de securité)

#### Token
(il faut switch vers votre compte personnel , doit etre owner)
https://github.com/settings/personal-access-tokens/new
- nommez le, expiration 90j ou +
- ressources owner => organisation
#### acces=> all repos
- permition 
- action RW
- issues RW
- workflow RW

#### Organisation acces
Projects RW

**[UPDATE]**
- copier le token

#### Personal acces tokens
votre token devrai etre dans "active token"

#### Secret , action
- cree un nouveau 
- nommez le (TEST pour ma part)
- et coller le token dedans puis sauvegarder.


#### Avoir un projet ouvert dans cette organisation
##### Modele utilisé par l'UR
https://github.com/orgs/UnionRolistes/projects/2
- (en haut a droite "use this template"

##### Workflow du projet
- item added to project => "new" 
- item closed => "ready-prod"
- et activer le en haut a droite

#### y ajouter les divers repositories
pensez a proteger la branche principale et a activer les issues pour tous.

#### Ajouter le yml
- aller dans `/.github/workflows/`
- cree un fichier "Add-issue-to-project.yml"
- avec comme contenu
```yml
name: Add-issue-to-project

on:
  issues:
    types:
      - opened

jobs:
  add-to-project:
    name: Add issue to project
    runs-on: ubuntu-latest
    steps:
      - uses: actions/add-to-project@v0.5.0
        with:
          # You can target a project in a different organization
          # to the issue
          project-url: https://github.com/orgs/UnionRolistes/projects/1/views/1
          github-token: ${{ secrets.TEST }}
```
- modifier les ligne 17 et 18 par vos propre infos
- dans mon cas mon secret action s'appel "TEST"
- faite votre commit / PR

-------------

### Mise à jour
#### Ligne 13 modifier 0.5.0! par la nouvelle version

-------------
### Usage
#### .
---

---
### how to contribue
-------------
