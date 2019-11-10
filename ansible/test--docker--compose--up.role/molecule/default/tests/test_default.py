import pytest
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


@pytest.mark.parametrize('path, content', [
    [ f'{test_dir}/volumes/{expected_container_name}/var/log/backbone/entry/entry.log', [ 'Started NGINX', 'Entry cascade succeeded' ] ],  # noqa: #501
    [ f'{test_dir}/volumes/{expected_container_name}/var/log/nginx/access.log', [ ] ],  # noqa: #501
    [ f'{test_dir}/volumes/{expected_container_name}/var/log/nginx/error.log', [ ] ],  # noqa: #501
])
def test_that_required_files_with_correct_content_exist(host, path, content):
    f = host.file(path)

    assert f.exists
    assert not f.is_directory

    fc = f.content_string

    for i in range(len(content)):
        assert content[i] in fc.splitlines()[i]
