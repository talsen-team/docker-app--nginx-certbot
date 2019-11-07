import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

test_dir = os.environ['TESTS_DIR'] + '/' + os.environ['ROLE_NAME']  # noqa: #501


@pytest.mark.parametrize('name', [
    '/bash/docker/image/build.bash',
])
def test_that_required_files_are_existing(host, name):

    f = host.file(test_dir + name)

    assert f.exists
    assert not f.is_directory
