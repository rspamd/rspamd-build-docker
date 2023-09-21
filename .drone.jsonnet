local ci_image = 'rspamd/ci';
local pkg_image = 'rspamd/pkg';

local ALPINE_VERSION = '3.17.0';
local FEDORA_VERSION = '38';
local UBUNTU_VERSION = '22.04';

local docker_defaults = {
  username: {
    from_secret: 'docker_username',
  },
  password: {
    from_secret: 'docker_password',
  },
};

local docker_pipeline = {
  kind: 'pipeline',
  type: 'docker',
  name: 'default-amd64',
  platform: {
    os: 'linux',
    arch: 'amd64',
  },
  steps: [
    {
      name: 'base_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-gcc/Dockerfile',
        label_schema: [
          'docker.dockerfile=ubuntu-gcc/Dockerfile',
        ],
        build_args: [
          'UBUNTU_VERSION=' + UBUNTU_VERSION,
        ],
        repo: ci_image,
        tags: [
          'ubuntu-gcc',
        ],
      } + docker_defaults,
    },
    {
      name: 'build_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-build/Dockerfile',
        label_schema: [
          'docker.dockerfile=ubuntu-build/Dockerfile',
        ],
        repo: ci_image,
        tags: [
          'ubuntu-build',
        ],
      } + docker_defaults,
      depends_on: [
        'base_image',
      ],
    },
    {
      name: 'test_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-test/Dockerfile',
        label_schema: [
          'docker.dockerfile=ubuntu-test/Dockerfile',
        ],
        repo: ci_image,
        tags: [
          'ubuntu-test',
        ],
      } + docker_defaults,
      depends_on: [
        'build_image',
      ],
    },
    {
      name: 'func_test_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-test-func/Dockerfile',
        label_schema: [
          'docker.dockerfile=ubuntu-test-func/Dockerfile',
        ],
        repo: ci_image,
        tags: [
          'ubuntu-test-func',
        ],
      } + docker_defaults,
      depends_on: [
        'test_image',
      ],
    },
    {
      name: 'perl_tidyall_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'perl-tidyall/Dockerfile',
        label_schema: [
          'docker.dockerfile=perl-tidyall/Dockerfile',
        ],
        build_args: [
          'ALPINE_VERSION=' + ALPINE_VERSION,
        ],
        repo: ci_image,
        tags: [
          'perl-tidyall',
        ],
      } + docker_defaults,
    },
    {
      name: 'fedora_build_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'fedora-build/Dockerfile',
        label_schema: [
          'docker.dockerfile=fedora-build/Dockerfile',
        ],
        build_args: [
          'FEDORA_VERSION=' + FEDORA_VERSION,
        ],
        repo: ci_image,
        tags: [
          'fedora-build',
        ],
      } + docker_defaults,
    },
    {
      name: 'fedora_test_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'fedora-test/Dockerfile',
        label_schema: [
          'docker.dockerfile=fedora-test/Dockerfile',
        ],
        build_args: [
          'FEDORA_VERSION=' + FEDORA_VERSION,
        ],
        repo: 'rspamd/ci',
        tags: [
          'fedora-test',
        ],
      } + docker_defaults,
      depends_on: [
        'fedora_build_image',
      ],
    },
    {
      name: 'centos8_pkg_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'centos-8/Dockerfile',
        label_schema: [
          'docker.dockerfile=centos-8/Dockerfile',
        ],
        repo: pkg_image,
        tags: [
          'centos-8',
        ],
      } + docker_defaults,
    },
    {
      name: 'centos9_pkg_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'centos-9/Dockerfile',
        label_schema: [
          'docker.dockerfile=centos-9/Dockerfile',
        ],
        repo: pkg_image,
        tags: [
          'centos-9',
        ],
      } + docker_defaults,
    },
    {
      name: 'centos7_pkg_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'centos-7/Dockerfile',
        label_schema: [
          'docker.dockerfile=centos-7/Dockerfile',
        ],
        repo: pkg_image,
        tags: [
          'centos-7',
        ],
      } + docker_defaults,
    },
    {
      name: 'ubuntu_jammy_pkg_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-jammy/Dockerfile',
        label_schema: [
          'docker.dockerfile=ubuntu-jammy/Dockerfile',
        ],
        repo: pkg_image,
        tags: [
          'ubuntu-jammy',
        ],
      } + docker_defaults,
    },
    {
      name: 'ubuntu_focal_pkg_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-focal/Dockerfile',
        label_schema: [
          'docker.dockerfile=ubuntu-focal/Dockerfile',
        ],
        repo: pkg_image,
        tags: [
          'ubuntu-focal',
        ],
      } + docker_defaults,
    },
    {
      name: 'debian_bullseye_pkg_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'debian-bullseye/Dockerfile',
        label_schema: [
          'docker.dockerfile=debian-bullseye/Dockerfile',
        ],
        repo: pkg_image,
        tags: [
          'debian-bullseye',
        ],
      } + docker_defaults,
    },
    {
      name: 'debian_bookworm_pkg_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'debian-bookworm/Dockerfile',
        label_schema: [
          'docker.dockerfile=debian-bookworm/Dockerfile',
        ],
        repo: pkg_image,
        tags: [
          'debian-bookworm',
        ],
      } + docker_defaults,
    },
  ],
  trigger: {
    branch: [
      'master',
    ],
    event: [
      'push',
      'tag',
      'custom',
    ],
  },
};

local signature_placeholder = {
  kind: 'signature',
  hmac: '0000000000000000000000000000000000000000000000000000000000000000',
};

[
  docker_pipeline,
  signature_placeholder,
]
