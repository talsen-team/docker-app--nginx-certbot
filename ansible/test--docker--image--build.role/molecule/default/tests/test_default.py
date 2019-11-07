import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

configuration = '127.0.0.1:80'
expected_image_name = 'talsenteam/docker-nginx-certbot:v1.17.4'
test_dir = os.environ['TESTS_DIR'] + '/' + os.environ['ROLE_NAME']  # noqa: #501


@pytest.mark.parametrize('name', [
    f'/bash/util/functions.bash',
    f'/bash/docker/image/build.bash',
    f'/docker/{ configuration }/default.docker',
    f'/docker/{ configuration }/default.docker-compose',
    f'/env/{ configuration }/docker-images.env',
])
def test_that_required_files_are_existing(host, name):
    f = host.file(test_dir + name)

    assert f.exists
    assert not f.is_directory


def test_that_required_docker_image_exists(host):
    c = host.run('docker images ' + expected_image_name + ' --format "{{.Repository}}:{{.Tag}}"')  # noqa: #501

    assert expected_image_name + '\n' == c.stdout
