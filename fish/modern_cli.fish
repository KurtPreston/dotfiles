# Modern CLI tool aliases for fish
# Each alias only applies when the replacement tool is installed.

# ripgrep: faster grep with smarter defaults (respects .gitignore, etc.)
if type -q rg
    alias grep='rg'
end

# fd: faster, friendlier find
if type -q fd
    alias find='fd'
end
