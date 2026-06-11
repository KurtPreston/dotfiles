# Auto-switch node version based on .nvmrc or package.json engines.node
# Uses the fisher nvm plugin (not bash nvm)

function _nvm_normalize_engine_spec --argument-names spec
    set spec (string trim $spec)
    if string match -qr '^v?\d+(\.\d+)?(\.\d+)?$' $spec
        echo $spec
        return
    end

    set -l major (string match -r '(\d+)' $spec | head -1)
    if test -n "$major"
        echo $major
    end
end

function nvm_auto_use
    if not type -q nvm
        return
    end

    set -l target_spec ""
    set -l source_label ""

    if set -l nvmrc (_nvm_find_up $PWD .nvmrc)
        set target_spec (string trim (cat $nvmrc))
        set source_label ".nvmrc"
    else if test -f package.json; and type -q jq
        set target_spec (jq -r '.engines.node // empty' package.json 2>/dev/null | string trim)
        if test -n "$target_spec"
            set target_spec (_nvm_normalize_engine_spec $target_spec)
            set source_label "package.json engines.node"
        end
    end

    if test -z "$target_spec"
        return
    end

    set -l current_version (nvm current 2>/dev/null)
    _nvm_list | string match --entire --regex -- (_nvm_version_match $target_spec) | read -l target_version __

    if test -n "$target_version"; and test "$target_version" = "$current_version"
        return
    end

    if test "$target_version" != "$current_version"
        echo "Found $source_label with version $target_spec. Switching from $current_version..."
        nvm use -s $target_spec
    end
end

# Only auto-switch in interactive shells (skips agents, CI, cron, piped shells;
# the PWD hook can't fire otherwise).
if status is-interactive
    function __nvm_auto_use_on_pwd --on-variable PWD
        nvm_auto_use
    end

    # Run once on shell startup for current directory
    nvm_auto_use
end
