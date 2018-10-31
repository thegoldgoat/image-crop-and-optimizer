# project name and programming language
project('com.github.thegoldgoat.image-crop-and-optimizer', 'vala', 'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    'src/imageApplication.vala',
        dependencies: [
            dependency('gtk+-3.0'),
            dependency('posix')
        ],
    install: true
)

#Install our .desktop file so the Applications Menu will see it
install_data(
    join_paths('data', meson.project_name() + '.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)