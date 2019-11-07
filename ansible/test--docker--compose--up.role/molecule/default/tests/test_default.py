import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

configuration = '127.0.0.1:80'
expected_container_name = 'server--nginx-certbot'
test_dir = os.environ['TESTS_DIR'] + '/' + os.environ['ROLE_NAME']  # noqa: #501


def test_that_required_docker_containers_are_running(host):
    c = host.run('docker ps --format "{{.Names}}"')  # noqa: #501

    assert expected_container_name + '\n' == c.stdout
