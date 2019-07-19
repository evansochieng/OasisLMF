__all__ = [
    'AdminCmd',
    'CreateComplexModelCmd',
    'CreateSimpleModelCmd',
]

import os
import re
import subprocess

from argparse import RawDescriptionHelpFormatter
from subprocess import (
    CalledProcessError,
    run
)

from ..utils.exceptions import OasisException
from ..utils.path import (
    as_path,
    empty_dir,
)
from ..utils.data import get_utctimestamp
from ..utils.defaults import STATIC_DATA_FP
from ..utils.path import as_path

from .base import (
    InputValues,
    OasisBaseCommand,
)


class CreateSimpleModelCmd(OasisBaseCommand):
    """
    Creates a local Git repository for a "simple model" (using the
    ``cookiecutter`` package) on a "simple model" repository template
    on GitHub)
    """
    formatter_class = RawDescriptionHelpFormatter

    cookiecutter_template_uri = 'git+ssh://git@github.com/OasisLMF/CookiecutterOasisSimpleModel'

    def add_args(self, parser):
        """
        Adds arguments to the argument parser.

        :param parser: The argument parser object
        :type parser: ArgumentParser
        """
        super(self.__class__, self).add_args(parser)

        parser.add_argument(
            '-p', '--preset-cookiecutter-json', default=None, required=False, help='Cookiecutter JSON file path with all options provided in the file'
        )
        parser.add_argument(
            '-i', '--no-input', default=None, help='Do not prompt for parameters and only use cookiecutter.json file content', action='store_true'
        )
        parser.add_argument(
            '-r', '--replay', default=None, help='Do not prompt for parameters and only use information entered previously', action='store_true'
        )
        parser.add_argument(
            '-f', '--overwrite-if-exists', default=None, help='Overwrite the contents of any preexisting project directory of the same name', action='store_true'
        )
        parser.add_argument(
            '-o', '--output-dir', default=None, required=False, help='Where to generate the project'
        )
        parser.add_argument(
            '-b', '--verbose-mode', default=None, required=False, help='Run cookiecutter in verbose mode', action='store_true'
        )
        parser.add_argument(
            '-c', '--cookiecutter-version', default=None, required=False, help='Cookiecutter version', action='store_true'
        )

    def action(self, args):
        """
        Command action

        :param args: The arguments from the command line
        :type args: Namespace
        """
        inputs = InputValues(args)

        preset_cookiecutter_json = as_path(
            inputs.get('preset_cookiecutter_json', required=False, is_path=True), label='Preset cookiecutter JSON', is_dir=False, preexists=True
        )

        no_prompt = inputs.get('no_input', default=False, required=False)

        replay = inputs.get('replay', default=False, required=False)

        overwrite = inputs.get('overwrite_if_exists', default=True, required=False)

        pkg_dir = os.path.join(os.path.dirname(__file__), os.pardir)

        target_dir = as_path(
            inputs.get('output_dir', default=os.path.join(pkg_dir, 'cookiecutter-run'), required=False, is_path=True), label='Target directory', is_dir=True, preexists=False
        )

        verbose = inputs.get('verbose_mode', default=False, required=False)

        cookiecutter_version = inputs.get('cookiecutter_version', default=False, required=False)

        def run_cmd(cmd_str):
            run(cmd_str.split(), check=True)

        cmd_str = 'cookiecutter'

        if not cookiecutter_version:
            os.chdir(STATIC_DATA_FP) if not preset_cookiecutter_json else os.chdir(os.path.dirname(preset_cookiecutter_json))
            cmd_str += ''.join([ 
                (' --no-input' if no_prompt or preset_cookiecutter_json else ''),
                (' --replay' if replay else ''), 
                (' --overwrite-if-exists' if overwrite else ''), 
                (' --output-dir {}'.format(target_dir) if target_dir else ''),
                (' --verbose ' if verbose else ' '), 
                self.cookiecutter_template_uri
            ])
        else:
            cmd_str += ' -V'

        self.logger.info('\nRunning cookiecutter command: {}\n'.format(cmd_str))

        try:
            run_cmd(cmd_str)
        except CalledProcessError as e:
            self.logger.error(e)


class CreateComplexModelCmd(OasisBaseCommand):
    """
    Creates a local Git repository for a "complex model" (using the
    ``cookiecutter`` package) on a "simple model" repository template
    on GitHub)
    """
    formatter_class = RawDescriptionHelpFormatter

    cookiecutter_template_uri = 'git+ssh://git@github.com/OasisLMF/CookiecutterOasisComplexModel' 

    def add_args(self, parser):
        """
        Adds arguments to the argument parser.

        :param parser: The argument parser object
        :type parser: ArgumentParser
        """
        super(self.__class__, self).add_args(parser)

        parser.add_argument(
            '-p', '--preset-cookiecutter-json', default=None, required=False, help='Cookiecutter JSON file path with all options provided in the file'
        )
        parser.add_argument(
            '-i', '--no-input', default=None, help='Do not prompt for parameters and only use cookiecutter.json file content', action='store_true'
        )
        parser.add_argument(
            '-r', '--replay', default=None, help='Do not prompt for parameters and only use information entered previously', action='store_true'
        )
        parser.add_argument(
            '-f', '--overwrite-if-exists', default=None, help='Overwrite the contents of any preexisting project directory of the same name', action='store_true'
        )
        parser.add_argument(
            '-o', '--output-dir', default=None, required=False, help='Where to generate the project'
        )
        parser.add_argument(
            '-b', '--verbose-mode', default=None, required=False, help='Run cookiecutter in verbose mode', action='store_true'
        )
        parser.add_argument(
            '-c', '--cookiecutter-version', default=None, required=False, help='Cookiecutter version', action='store_true'
        )

    def action(self, args):
        """
        Command action

        :param args: The arguments from the command line
        :type args: Namespace
        """
        inputs = InputValues(args)

        preset_cookiecutter_json = as_path(
            inputs.get('preset_cookiecutter_json', required=False, is_path=True), label='Preset cookiecutter JSON', is_dir=False, preexists=True
        )

        no_prompt = inputs.get('no_input', default=False, required=False)

        replay = inputs.get('replay', default=False, required=False)

        overwrite = inputs.get('overwrite_if_exists', default=True, required=False)

        pkg_dir = os.path.join(os.path.dirname(__file__), os.pardir)

        target_dir = as_path(
            inputs.get('output_dir', default=os.path.join(pkg_dir, 'cookiecutter-run'), required=False, is_path=True), label='Target directory', is_dir=True, preexists=False
        )

        verbose = inputs.get('verbose_mode', default=False, required=False)

        cookiecutter_version = inputs.get('cookiecutter_version', default=False, required=False)

        def run_cmd(cmd_str):
            run(cmd_str.split(), check=True)

        cmd_str = 'cookiecutter'

        if not cookiecutter_version:
            os.chdir(STATIC_DATA_FP) if not preset_cookiecutter_json else os.chdir(os.path.dirname(preset_cookiecutter_json))
            cmd_str += ''.join([ 
                (' --no-input' if no_prompt or preset_cookiecutter_json else ''), 
                (' --replay' if replay else ''), 
                (' --overwrite-if-exists' if overwrite else ''), 
                (' --output-dir {}'.format(target_dir) if target_dir else ''), 
                (' --verbose ' if verbose else ' '), 
                self.cookiecutter_template_uri
            ])
        else:
            cmd_str += ' -V'

        self.logger.info('\nRunning cookiecutter command: {}\n'.format(cmd_str))

        try:
            run_cmd(cmd_str)
        except CalledProcessError as e:
            self.logger.error(e)

class AdminCmd(OasisBaseCommand):
    """
    Admin subcommands::

        * creates a local Git repository for a "simple model" (using the
          ``cookiecutter`` package) on a "simple model" repository template
          on GitHub)
        * creates a local Git repository for a "complex model" (using the
          ``cookiecutter`` package) on a "complex model" repository template
          on GitHub)
    """
    sub_commands = {
        'create-simple-model': CreateSimpleModelCmd,
        'create-complex-model': CreateComplexModelCmd
    }
