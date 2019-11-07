import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

configuration = '127.0.0.1:80'
test_dir = os.environ['TESTS_DIR'] + '/' + os.environ['ROLE_NAME']  # noqa: #501


@pytest.mark.parametrize('name', [
    f'/bash/util/functions.bash',
    f'/bash/docker/compose/up.bash',
    f'/docker/{ configuration }/default.docker',
    f'/docker/{ configuration }/default.docker-compose',
    f'/env/{ configuration }/docker-images.env',
])
def test_that_required_files_are_existing(host, name):
    f = host.file(test_dir + name)

    assert f.exists
    assert not f.is_directory
