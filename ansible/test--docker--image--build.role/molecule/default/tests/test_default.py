import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

test_dir = os.environ['TESTS_DIR'] + '/test--docker-compose--compose--create'  # noqa: #501


@pytest.mark.parametrize('name', [
    '',
])
def test_that_required_files_are_existing(host, name):

    f = host.file(test_dir + name)

    assert f.exists
    assert not f.is_directory
