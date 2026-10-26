#!/usr/bin/env bash
# Устанавливает/переносит skill plan-tree в личный (personal) каталог
# Claude Code на этой машине: ~/.claude/skills/plan-tree (или
# $CLAUDE_CONFIG_DIR/skills/plan-tree, если переменная задана).
#
# Использование:
#   bash install.sh <путь-к-папке-skill-источника>
#
# Источник — это папка, содержащая SKILL.md (например скопированная с
# другой машины через scp/AirDrop/флешку). Если скрипт запущен из самой
# папки skill без аргумента, источником считается её родитель.
set -euo pipefail

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${1:-$SELF_DIR}"

if [[ ! -f "$SRC/SKILL.md" ]]; then
  echo "Ошибка: $SRC/SKILL.md не найден — укажите папку, где лежит SKILL.md." >&2
  exit 1
fi

BASE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
DEST="$BASE_DIR/skills/plan-tree"

echo "Источник:     $SRC"
echo "Назначение:   $DEST"
echo ""

# Проверка на абсолютные пути текущей машины внутри SKILL.md/templates —
# такие пути сломались бы при переносе на другую машину с другим $HOME.
if grep -rlE "/Users/[A-Za-z0-9_.-]+|/home/[A-Za-z0-9_.-]+" "$SRC/SKILL.md" "$SRC/templates" 2>/dev/null; then
  echo "ВНИМАНИЕ: найдены абсолютные пути внутри файлов skill (см. выше)." >&2
  echo "Это может быть специфично для исходной машины и сломаться здесь." >&2
  echo "Проверьте вручную перед продолжением (Ctrl+C для отмены)." >&2
  read -r -p "Продолжить установку как есть? [y/N] " ans
  if [[ ! "$ans" =~ ^[Yy]$ ]]; then
    echo "Отменено."
    exit 1
  fi
fi

mkdir -p "$BASE_DIR/skills"

if [[ -e "$DEST" ]]; then
  echo "На этой машине уже есть $DEST."
  read -r -p "Перезаписать существующую установку? [y/N] " ans
  if [[ ! "$ans" =~ ^[Yy]$ ]]; then
    echo "Отменено, существующая установка не тронута."
    exit 1
  fi
  BACKUP="${DEST}.bak.$(date +%Y%m%d%H%M%S)"
  mv "$DEST" "$BACKUP"
  echo "Старая версия сохранена как $BACKUP"
fi

cp -R "$SRC" "$DEST"
# install.sh и README.md внутрь копии не нужны дублировать себя рекурсивно,
# но cp -R их всё равно скопирует как обычные файлы — это безопасно,
# просто оставляем как есть, чтобы DEST был самодостаточной копией.

echo ""
echo "Установлено: $DEST"
echo ""
echo "Дальше:"
echo "  1. В любой уже открытой сессии Claude Code выполните /reload-skills"
echo "     (новые сессии подхватят skill автоматически, без этой команды)."
echo "  2. Проверьте список через /skills — plan-tree должен появиться."
echo ""
echo "Не забудьте (если нужно) перенести отдельно:"
echo "  - skillOverrides для plan-tree из ~/.claude/settings.json старой машины"
echo "  - данные деревьев plan/<slug>/ — это часть проекта, не этого skill"
