#
# Copyright:: Copyright (c) 2017 GitLab Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require "#{Omnibus::Config.project_root}/lib/gitlab/ohai_helper.rb"

name 'libgcrypt'
default_version '1.8.6'

dependency 'libgpg-error'

license 'LGPL-2.1'
license_file 'COPYING.LIB'

skip_transitive_dependency_licensing true

source url: "https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-#{version}.tar.bz2",
       sha256: '0cba2700617b99fc33864a0c16b1fa7fdf9781d9ed3509f5d767178e5fd7b975'

relative_path "libgcrypt-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  configure_options = ["--prefix=#{install_dir}/embedded", "--disable-doc"]
  configure_options += %w(host build).map { |w| "--#{w}=#{OhaiHelper.gcc_target}" } if OhaiHelper.raspberry_pi?
  configure(*configure_options, env: env)

  make "-j #{workers}", env: env
  make 'install', env: env
end

project.exclude "embedded/bin/libgcrypt-config"
