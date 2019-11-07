import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

configuration = '127.0.0.1:80'
expected_container_name = 'server--nginx-certbot'
test_dir = os.environ['TESTS_DIR'] + '/' + os.environ['ROLE_NAME']  # noqa: #501


@pytest.mark.parametrize('name', [
    f'/bash/util/functions.bash',
    f'/bash/docker/compose/up.bash',
    f'/docker/{ configuration }/default.docker',
    f'/docker/{ configuration }/default.docker-compose',
    f'/env/{ configuration }/docker-containers.env',
    f'/env/{ configuration }/docker-images.env',
])
def test_that_required_files_are_existing(host, name):
    f = host.file(test_dir + name)

    assert f.exists
    assert not f.is_directory


def test_that_required_docker_containers_are_running(host):
    c = host.run('docker ps --format "{{.Names}}"')  # noqa: #501

    assert expected_container_name + '\n' == c.stdout
