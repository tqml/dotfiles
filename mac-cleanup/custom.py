"""Custom module template example."""
from mac_cleanup import Path, Command, Collector


# Do not import any functions at the top level

# Get an instance of Collector
clc = Collector()

print("custom")


def docker_orb():
    from mac_cleanup.utils import cmd, check_exists, check_deletable

    print("orb")
    if cmd("type 'orb'"):
        with clc as unit:
            unit.message("Cleaning up Docker")

            # Flag for turning Docker off
            if not cmd("docker --context orbstack ps >/dev/null 2>&1"):
                unit.add(Command("open -jga Orbstack"))
            unit.add(
                Command("docker --context orbstack system prune -af").with_prompt(
                    "Stopped containers, dangling images, unused networks, volumes, and build cache will be deleted.\n" "Continue?"
                )
            )


def local_test():
    from mac_cleanup.utils import cmd, check_exists, check_deletable
    import pathlib

    root = pathlib.Path(__file__).parent
    test_file = root / "test" / "test.txt"
    test_file.touch()

    print("local test")

    if check_exists(test_file):
        with clc as unit:
            unit.message("Deleting test file")
            unit.add(Path(test_file.as_posix()))


# Deletes Pip cache
def pip():
    from mac_cleanup.utils import cmd, check_exists, check_deletable

    print("pip")
    if cmd("type 'pip'") or check_exists("~/Library/Caches/pip"):
        with clc as unit:
            unit.message("Deleting pip cache")

            pip_cache_dir = cmd("pip cache dir")

            unit.add(Command("pip cache purge"))
            unit.add(Path(pip_cache_dir))


def terraform():
    from mac_cleanup.utils import cmd, check_exists, check_deletable

    terraform_plugin_path = "~/.terraform.d/plugin-cache"  # assume the default

    # check if .terraformrc exists
    # if check_exists("~/.terraformrc"):
    #     with open("~/.terraformrc", "w") as f:
    #         # search for line with 'plugin_cache_dir'
    #         for line in f.readlines():
    #             if "plugin_cache_dir" in line:
    #                 # delete line
    #                 _, value = line.split("=")
    #                 terraform_plugin_path = value.strip()

    if check_exists(terraform_plugin_path):
        with clc as unit:
            unit.message("Deleting terraform cache")
            unit.add(Path(terraform_plugin_path).with_prompt("All local terraform plugins will be deleted.\n" "Continue?"))


# Module's name in configuration screen == function name
# def module_example_1():
#     # Import anything you need from utils here
#     from mac_cleanup.utils import check_exists, cmd

#     # check_exists - checks if specified path exists
#     if check_exists("~/example/path"):
#         # Open context manager of Collector
#         with clc as unit:
#             # message() - sets message to be displayed in the progress bar
#             unit.message("Message you want to see in progress bar")

#             # add() - adds desired module to modules list
#             unit.add(
#                 # Path - used for deleting paths
#                 Path("~/example/path")
#                 # with_prompt - calls for user prompt to approve "risky" action
#                 # You can specify question in prompt with optional attr "message_"
#                 .with_prompt()
#             )

#             unit.add(
#                 Path("~/example/dry_run/file.webm")
#                 # dry_run_only - specified path will be counted in dry run, but won't be deleted
#                 .dry_run_only()
#             )

#             # cmd() - executes specified command and return stdout only
#             # stderr can be returned with attr "ignore_errors" set to False
#             if cmd("echo 1") == "1":
#                 unit.add(
#                     # Command - used for executing any command with :func:`mac_cleanup.utils.cmd`
#                     Command("whoami").with_prompt("You will see your username. Proceed?")
#                     # with_errors - adds stderr to return of command execution
#                     .with_errors()
#                 )


# # You can create lots of modules in one file
# def module_example_2():
#     pass
