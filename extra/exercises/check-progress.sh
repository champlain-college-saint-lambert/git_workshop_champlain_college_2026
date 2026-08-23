#!/bin/bash

# Progress tracking script for Git Workshop exercises
# Tracks completion of exercises and provides statistics

PROGRESS_FILE="$HOME/.git_workshop_progress"
EXERCISES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# Exercise definitions
declare -a EXERCISES=(
    "01-basic-setup:Basic Git Setup:Beginner"
    "02-first-repo:Creating Your First Repository:Beginner"
    "03-basic-workflow:Basic Add, Commit, Push:Beginner"
    "04-remotes:Working with Remote Repositories:Beginner"
    "05-branching:Branching and Merging:Intermediate"
    "06-conflicts:Resolving Merge Conflicts:Intermediate"
    "07-stash-reset:Git Stash and Reset:Intermediate"
    "08-rebase:Interactive Rebase:Intermediate"
    "09-workflows:Git Workflows:Advanced"
    "10-hooks:Git Hooks and Automation:Advanced"
    "11-advanced:Advanced Git Operations:Advanced"
    "12-best-practices:Git Best Practices:Advanced"
)

# Initialize progress file if it doesn't exist
init_progress() {
    if [[ ! -f "$PROGRESS_FILE" ]]; then
        echo "# Git Workshop Progress File" > "$PROGRESS_FILE"
        echo "# Format: exercise_id:status:timestamp" >> "$PROGRESS_FILE"
    fi
}

# Check if exercise is completed
is_completed() {
    local exercise_id="$1"
    if [[ -f "$PROGRESS_FILE" ]]; then
        grep -q "^$exercise_id:completed:" "$PROGRESS_FILE"
    else
        return 1
    fi
}

# Mark exercise as completed
mark_completed() {
    local exercise_id="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    init_progress
    
    # Remove existing entry for this exercise
    grep -v "^$exercise_id:" "$PROGRESS_FILE" > "$PROGRESS_FILE.tmp"
    mv "$PROGRESS_FILE.tmp" "$PROGRESS_FILE"
    
    # Add new completion entry
    echo "$exercise_id:completed:$timestamp" >> "$PROGRESS_FILE"
}

# Get completion statistics
get_stats() {
    local total=${#EXERCISES[@]}
    local completed=0
    local beginner_total=0
    local beginner_completed=0
    local intermediate_total=0
    local intermediate_completed=0
    local advanced_total=0
    local advanced_completed=0
    
    for exercise in "${EXERCISES[@]}"; do
        IFS=':' read -r id name level <<< "$exercise"
        
        case "$level" in
            "Beginner")
                ((beginner_total++))
                if is_completed "$id"; then
                    ((beginner_completed++))
                    ((completed++))
                fi
                ;;
            "Intermediate")
                ((intermediate_total++))
                if is_completed "$id"; then
                    ((intermediate_completed++))
                    ((completed++))
                fi
                ;;
            "Advanced")
                ((advanced_total++))
                if is_completed "$id"; then
                    ((advanced_completed++))
                    ((completed++))
                fi
                ;;
        esac
    done
    
    echo "$completed:$total:$beginner_completed:$beginner_total:$intermediate_completed:$intermediate_total:$advanced_completed:$advanced_total"
}

# Display progress
show_progress() {
    init_progress
    
    echo -e "${BOLD}🎓 Git Workshop Progress${NC}"
    echo "========================="
    
    # Get statistics
    IFS=':' read -r completed total beginner_comp beginner_tot intermediate_comp intermediate_tot advanced_comp advanced_tot <<< "$(get_stats)"
    
    # Overall progress
    local percentage=$((completed * 100 / total))
    echo -e "Overall Progress: ${BLUE}$completed/$total${NC} exercises completed (${BLUE}$percentage%${NC})"
    echo
    
    # Progress by level
    echo -e "${GREEN}🌱 Beginner:${NC} $beginner_comp/$beginner_tot"
    echo -e "${YELLOW}🌿 Intermediate:${NC} $intermediate_comp/$intermediate_tot"
    echo -e "${RED}🌳 Advanced:${NC} $advanced_comp/$advanced_tot"
    echo
    
    # Detailed exercise list
    echo -e "${BOLD}Exercise Details:${NC}"
    echo "=================="
    
    for exercise in "${EXERCISES[@]}"; do
        IFS=':' read -r id name level <<< "$exercise"
        
        local status_icon="❌"
        local status_color="$RED"
        
        if is_completed "$id"; then
            status_icon="✅"
            status_color="$GREEN"
        fi
        
        printf "%-3s %-20s %-40s %s\n" "$status_icon" "($level)" "$name" ""
    done
    
    echo
    
    # Next recommendation
    if [[ $completed -eq $total ]]; then
        echo -e "${GREEN}🎉 Congratulations! You've completed all exercises!${NC}"
        echo "Run './generate-certificate.sh' to get your completion certificate!"
    else
        # Find next uncompleted exercise
        for exercise in "${EXERCISES[@]}"; do
            IFS=':' read -r id name level <<< "$exercise"
            if ! is_completed "$id"; then
                echo -e "${BLUE}👉 Next: Exercise $id - $name${NC}"
                break
            fi
        done
    fi
}

# Auto-check and mark completion
auto_check() {
    local exercise_id="$1"
    local exercise_dir="$EXERCISES_DIR/$exercise_id"
    
    if [[ -f "$exercise_dir/validate.sh" ]]; then
        if bash "$exercise_dir/validate.sh" >/dev/null 2>&1; then
            mark_completed "$exercise_id"
            echo -e "${GREEN}✅ Exercise $exercise_id marked as completed!${NC}"
            return 0
        fi
    fi
    return 1
}

# Main execution
case "${1:-}" in
    "show"|"")
        show_progress
        ;;
    "check")
        if [[ -n "$2" ]]; then
            auto_check "$2"
        else
            echo "Usage: $0 check <exercise_id>"
            exit 1
        fi
        ;;
    "mark")
        if [[ -n "$2" ]]; then
            mark_completed "$2"
            echo -e "${GREEN}✅ Exercise $2 marked as completed!${NC}"
        else
            echo "Usage: $0 mark <exercise_id>"
            exit 1
        fi
        ;;
    "reset")
        if [[ -n "$2" ]]; then
            grep -v "^$2:" "$PROGRESS_FILE" > "$PROGRESS_FILE.tmp" 2>/dev/null || touch "$PROGRESS_FILE.tmp"
            mv "$PROGRESS_FILE.tmp" "$PROGRESS_FILE"
            echo -e "${YELLOW}🔄 Exercise $2 progress reset!${NC}"
        else
            echo "Usage: $0 reset <exercise_id>"
            exit 1
        fi
        ;;
    "stats")
        IFS=':' read -r completed total beginner_comp beginner_tot intermediate_comp intermediate_tot advanced_comp advanced_tot <<< "$(get_stats)"
        echo "completed:$completed"
        echo "total:$total"
        echo "percentage:$((completed * 100 / total))"
        echo "beginner:$beginner_comp/$beginner_tot"
        echo "intermediate:$intermediate_comp/$intermediate_tot"
        echo "advanced:$advanced_comp/$advanced_tot"
        ;;
    *)
        echo "Git Workshop Progress Tracker"
        echo "Usage: $0 [command] [args]"
        echo "Commands:"
        echo "  show (default) - Show progress overview"
        echo "  check <id>     - Auto-check and mark exercise completion"
        echo "  mark <id>      - Manually mark exercise as completed"
        echo "  reset <id>     - Reset exercise progress"
        echo "  stats          - Raw statistics for scripting"
        exit 1
        ;;
esac
