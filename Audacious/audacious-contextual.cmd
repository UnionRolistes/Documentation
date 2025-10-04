#!/bin/bash

# ------------------------------
# Script Bash pour configurer Audacious sur Windows
# ------------------------------

# Chemin par défaut de l'exécutable Audacious
AUDACIOUS_PATH="C:\\Program Files (x86)\\Audacious\\bin\\audacious.exe"

# Sauvegarde complète du registre
echo "📦 Exportation du registre dans C:\\before.reg..."
reg export "HKCR" "C:\\before.reg" /y

# Vérifier si Audacious est installé
if [ ! -f "$AUDACIOUS_PATH" ]; then
    echo "⚠️ Audacious n'est pas trouvé, ouverture du navigateur..."
    start "" "https://github.com/audacious-media-player/audacious/releases"
    exit 1
fi

# Fonction pour modifier une clé de shell audio/dossier
modify_shell_entry() {
    KEY="$1"         # exemple: HKEY_CLASSES_ROOT\SystemFileAssociations\audio\shell\Play
    MENU_TEXT="$2"   # texte affiché dans le menu contextuel
    CMD="$3"         # commande à exécuter (ex: "%AUDACIOUS_PATH% \"%1\"" ou "%AUDACIOUS_PATH% -e \"%1\"")
    
    echo "🔧 Traitement de la clé: $KEY"
    
    # Renommer DelegateExecute si existant
    DELEGATE_PATH="$KEY\command"
    DELEGATE_NAME="DelegateExecute"
    OLD_DELEGATE_NAME="old-DelegateExecute"
    if reg query "$DELEGATE_PATH" /v "$DELEGATE_NAME" > /dev/null 2>&1; then
        echo "Renommage de DelegateExecute en old-DelegateExecute..."
        reg copy "$DELEGATE_PATH" "$DELEGATE_PATH" /v "$DELEGATE_NAME" /reg:32 /f
        reg delete "$DELEGATE_PATH" /v "$DELEGATE_NAME" /f
        reg add "$DELEGATE_PATH" /v "$OLD_DELEGATE_NAME" /t REG_SZ /d "{45597c98-80f6-4549-84ff-752cf55e2d29}" /f
    fi

    # Modifier MUIVerb
    reg add "$KEY" /v "MUIVerb" /t REG_SZ /d "$MENU_TEXT" /f

    # Ajouter l'icône
    reg add "$KEY" /v "Icon" /t REG_SZ /d "\"$AUDACIOUS_PATH\",0" /f

    # Modifier la commande pour Audacious
    reg add "$DELEGATE_PATH" /ve /t REG_SZ /d "\"$CMD\"" /f
}

# Définir les chemins à modifier et leurs commandes
# Fichiers audio
modify_shell_entry "HKEY_CLASSES_ROOT\SystemFileAssociations\audio\shell\Play" "Lire avec Audacious" "$AUDACIOUS_PATH \"%1\""
modify_shell_entry "HKEY_CLASSES_ROOT\SystemFileAssociations\audio\shell\Enqueue" "Add to Audacious Playlist" "$AUDACIOUS_PATH -e \"%1\""

# Dossiers audio
modify_shell_entry "HKEY_CLASSES_ROOT\SystemFileAssociations\Directory.Audio\shell\Play" "Lire avec Audacious" "$AUDACIOUS_PATH \"%1\""
modify_shell_entry "HKEY_CLASSES_ROOT\SystemFileAssociations\Directory.Audio\shell\Enqueue" "Add to Audacious Playlist" "$AUDACIOUS_PATH -e \"%1\""

echo "✅ Modification terminée !"

# ------------------------------
# Vérification lecteur par défaut audio
# ------------------------------
DEFAULT_MP3_PROGID=$(reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mp3\UserChoice" /v ProgId 2> /dev/null | grep ProgId | awk '{print $3}')

if [[ "$DEFAULT_MP3_PROGID" != "Audacious.mp3" ]]; then
    echo "🎵 Audacious n'est pas le lecteur par défaut pour les fichiers audio. Configuration..."
    # Cette partie est délicate à faire en ligne de commande pure Windows
    # Solution simplifiée: lancer l'interface de définition par défaut
    start "" "ms-settings:defaultapps"
    echo "⚠️ Veuillez sélectionner Audacious comme lecteur audio par défaut manuellement."
fi

echo "✔️ Script terminé !"
