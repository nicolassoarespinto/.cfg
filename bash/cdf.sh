cdf() {
  # Ignored directory patterns (edit freely)
  local ignore_patterns=(
    "__pycache__", "miniconda" 
  )

  # Build ignore options for fzf --walker-ignore
  local ignore_opts=()
  for pat in "${ignore_patterns[@]}"; do
    ignore_opts+=(--walker-ignore "$pat")
  done

  # Choose root: use argument if given, otherwise current dir
  local root="${1:-.}"

  # You can toggle between 'pretty' and 'simple' modes here
  local mode="pretty"

  if [[ $mode == "pretty" ]]; then
    cd "$(
      fzf \
        --walker dir \
        --walker-root "$root" \
        "${ignore_opts[@]}" \
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
        "${ignore_opts[@]}"
    )" || return
  fi
}

