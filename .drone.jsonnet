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

local pipeline_defaults = {
  kind: 'pipeline',
  type: 'docker',
};

local trigger = {
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

local tidyall_pipeline = {
  name: 'tidyall',
  steps: [
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
  ],
} + trigger + pipeline_defaults;

local platform(arch) = {
  platform: {
    os: 'linux',
    arch: arch,
  },
};

local build_base_image(arch) = {
  name: 'base_image_' + arch,
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
          'ubuntu-gcc-' + arch,
        ],
      } + docker_defaults,
    },
  ],
} + platform(arch) + trigger + pipeline_defaults;

local build_test_image(arch) = {
  depends_on: [
    'base_image_' + arch,
    'build_image_' + arch,
  ],
  name: 'test_image_' + arch,
  steps: [
    {
      name: 'test_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-test/Dockerfile',
        build_args: [
          std.format('UBUNTU_BUILD_IMAGE=%s:ubuntu-build-%s', [ci_image, arch]),
          std.format('UBUNTU_GCC_IMAGE=%s:ubuntu-gcc-%s', [ci_image, arch]),
        ],
        label_schema: [
          'docker.dockerfile=ubuntu-test/Dockerfile',
        ],
        repo: ci_image,
        tags: [
          'ubuntu-test-' + arch,
        ],
        volumes: [
          {
            name: 'dump-ubuntu',
            path: '/dump',
          },
        ],
      } + docker_defaults,
    },
  ],
  volumes: [
    {
      name: 'dump-ubuntu',
      temp: {},
    },
  ],
} + platform(arch) + trigger + pipeline_defaults;

local build_build_image(arch) = {
  depends_on: [
    'base_image_' + arch,
  ],
  name: 'build_image_' + arch,
  steps: [
    {
      name: 'build_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-build/Dockerfile',
        build_args: [
          std.format('UBUNTU_GCC_IMAGE=%s:ubuntu-gcc-%s', [ci_image, arch]),
        ],
        label_schema: [
          'docker.dockerfile=ubuntu-build/Dockerfile',
        ],
        repo: ci_image,
        tags: [
          'ubuntu-build-' + arch,
        ],
      } + docker_defaults,
    },
  ],
} + platform(arch) + trigger + pipeline_defaults;

local build_fedora_build_image(arch) = {
  name: 'fedora_build_image_' + arch,
  steps: [
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
          'fedora-build-' + arch,
        ],
      } + docker_defaults,
    },
  ],
} + platform(arch) + trigger + pipeline_defaults;

local build_ci_images(arch) = {
  depends_on: [
    'build_image_' + arch,
    'fedora_build_image_' + arch,
    'test_image_' + arch,
  ],
  name: 'ci-images-' + arch,
  steps: [
    {
      name: 'func_test_image',
      image: 'plugins/docker',
      settings: {
        dockerfile: 'ubuntu-test-func/Dockerfile',
        build_args: [
          std.format('UBUNTU_TEST_IMAGE=%s:ubuntu-test-%s', [ci_image, arch]),
        ],
        label_schema: [
          'docker.dockerfile=ubuntu-test-func/Dockerfile',
        ],
        repo: ci_image,
        tags: [
          'ubuntu-test-func-' + arch,
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
          std.format('FEDORA_BUILD_IMAGE=%s:fedora-build-%s', [ci_image, arch]),
          'FEDORA_VERSION=' + FEDORA_VERSION,
        ],
        repo: ci_image,
        tags: [
          'fedora-test-' + arch,
        ],
        volumes: [
          {
            name: 'dump-fedora',
            path: '/dump',
          },
        ],
      } + docker_defaults,
    },
  ],
  volumes: [
    {
      name: 'dump-fedora',
      temp: {},
    },
  ],
} + platform(arch) + trigger + pipeline_defaults;

local build_pkg_images(arch) = {
  name: 'pkg-images-' + arch,
  steps: [
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
          'centos-8-' + arch,
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
          'centos-9-' + arch,
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
          'centos-7-' + arch,
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
          'ubuntu-jammy-' + arch,
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
          'ubuntu-focal-' + arch,
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
          'debian-bullseye-' + arch,
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
          'debian-bookworm-' + arch,
        ],
      } + docker_defaults,
    },
  ],
} + platform(arch) + trigger + pipeline_defaults;

local multiarch_step(step_name, image_name, image_tag) = {
  name: step_name,
  image: 'plugins/manifest',
  settings: {
    target: std.format('%s:%s', [image_name, image_tag]),
    template: std.format('%s:%s-ARCH', [image_name, image_tag]),
    platforms: [
      'linux/amd64',
      'linux/arm64',
    ],
  } + docker_defaults,
};

local multiarch_ci_images = {
  name: 'multiarch_ci_images',
  depends_on: [
    'ci-images-amd64',
    'ci-images-arm64',
  ],
  steps: [
    multiarch_step('ci_ubuntu_build', ci_image, 'ubuntu-build'),
    multiarch_step('ci_ubuntu_gcc', ci_image, 'ubuntu-gcc'),
    multiarch_step('ci_ubuntu_test', ci_image, 'ubuntu-test'),
    multiarch_step('ci_ubuntu_test_func', ci_image, 'ubuntu-test-func'),
    multiarch_step('ci_fedora_build', ci_image, 'fedora-build'),
    multiarch_step('ci_fedora_test', ci_image, 'fedora-test'),
  ],
} + trigger + pipeline_defaults;

local multiarch_pkg_images = {
  name: 'multiarch_pkg_images',
  depends_on: [
    'pkg-images-amd64',
    'pkg-images-arm64',
  ],
  steps: [
    multiarch_step('pkg_centos7', pkg_image, 'centos-7'),
    multiarch_step('pkg_centos8', pkg_image, 'centos-8'),
    multiarch_step('pkg_centos9', pkg_image, 'centos-9'),
    multiarch_step('pkg_ubuntu2004', pkg_image, 'ubuntu-focal'),
    multiarch_step('pkg_ubuntu2204', pkg_image, 'ubuntu-jammy'),
    multiarch_step('pkg_debian11', pkg_image, 'debian-bullseye'),
    multiarch_step('pkg_debian12', pkg_image, 'debian-bookworm'),
  ],
} + trigger + pipeline_defaults;

local signature_placeholder = {
  kind: 'signature',
  hmac: '0000000000000000000000000000000000000000000000000000000000000000',
};

[
  build_base_image('amd64'),
  build_base_image('arm64'),
  build_build_image('amd64'),
  build_build_image('arm64'),
  build_fedora_build_image('amd64'),
  build_fedora_build_image('arm64'),
  build_test_image('amd64'),
  build_test_image('arm64'),
  build_ci_images('amd64'),
  build_ci_images('arm64'),
  build_pkg_images('amd64'),
  build_pkg_images('arm64'),
  multiarch_ci_images,
  multiarch_pkg_images,
  tidyall_pipeline,
  signature_placeholder,
]
