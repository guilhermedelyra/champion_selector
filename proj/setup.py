from cx_Freeze import setup, Executable

base = None
executables = [Executable("test2.py", base=base)]

packages = ["tkinter", "idna", "sys", "urllib", "json","collections"]
options = {
    'build_exe': {    
        'packages':packages,
    },    
}

setup(
    name = "Melhor champ",
    options = options,
    version = "1.0.0",
    description = 'acha o melhor champ dependendo do matchup <consumido la do champion.gg>',
    executables = executables
)