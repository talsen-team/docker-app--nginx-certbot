import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

test_dir = os.environ['TESTS_DIR'] + '/' + os.environ['ROLE_NAME']  # noqa: #501


@pytest.mark.parametrize('name', [
    '/bash/util/functions.bash',
    '/bash/docker/image/build.bash',
    '/docker/127.0.0.1:80/default.docker',
    '/docker/127.0.0.1:80/default.docker-compose',
    '/env/127.0.0.1:80/docker-images.env',
])
def test_that_required_files_are_existing(host, name):
    f = host.file(test_dir + name)

    assert f.exists
    assert not f.is_directory


def test_that_required_docker_image_exists(host):
    x = host.run('cat ' + test_dir + '/env/127.0.0.1:80/docker-images.env')  # noqa: #501

    expected_image_name = x.stdout.splitlines()[0].split('=', 2)[1]

    c = host.run('docker images ' + expected_image_name + ' --format "{{.Repository}}:{{.Tag}}"')  # noqa: #501

    assert expected_image_name + '\n' == c.stdout
