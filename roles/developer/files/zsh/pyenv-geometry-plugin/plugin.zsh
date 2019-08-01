# Color definitions
DEFAULT_COLOR=${GEOMETRY_COLOR_PROMPT:-green}
GEOMETRY_COLOR_VIRTUALENV=${GEOMETRY_COLOR_VIRTUALENV:-$DEFAULT_COLOR}
GEOMETRY_COLOR_CONDA=${GEOMETRY_COLOR_CONDA:-$DEFAULT_COLOR}
GEOMETRY_VIRTUALENV_CONDA_SEPARATOR=${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR:-:}


geometry_prompt_pyenv_setup() {}

geometry_prompt_pyenv_check() {
    [ -n "${VIRTUAL_ENV}" -o -n "${CONDA_PREFIX}" ]
}

geometry_prompt_pyenv_render() {

    local environment_str=""
    # Add virtualenv name if active
    if [ -n "${PYENV_VIRTUAL_ENV}" ]; then
        local virtualenv_ref=$(pyenv local 2>/dev/null)
        environment_str="$(prompt_geometry_colorize $GEOMETRY_COLOR_VIRTUALENV ${virtualenv_ref})"
    fi

    # Print to stdout
    echo "${environment_str}"

}
