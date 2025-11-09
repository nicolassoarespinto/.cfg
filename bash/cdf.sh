cdf() {
# Ignored directory patterns (edit freely)
local ignore_patterns=(
  "__pycache__", "miniconda", ".venv",
)

# Build skip list for fzf
local skip_list
skip_list=$(IFS=,; echo "${ignore_patterns[*]}")

# Choose root: use argument if given, otherwise current dir
local root="${1:-.}"

# You can toggle between 'pretty' and 'simple' modes here
local mode="pretty"

if [[ $mode == "pretty" ]]; then
  cd "$(
    fzf \
      --walker dir \
      --walker-root "$root" \
      --walker-skip "$skip_list" \
      --preview 'ls --color=always -A {}' \
      --height=40% \
      --reverse \
      --border
  )" || return
else
  cd "$(
    fzf \
      --walker dir \
      --walker-root "$root" \
      --walker-skip "$skip_list"
  )" || return
fi
}
