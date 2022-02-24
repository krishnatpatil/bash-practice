%define __jar_repack %{nil}
%define module_deploy_dir /apps/Python-2.7.14/lib/python2.7/site-packages/test_client
%define module_deploy_group test
%define module_deploy_user test
%define cli_deploy_dir /apps/test-client

Summary:    %{DELIVERABLENAME}
Name:       %{RPMNAME}
Version:    %{VERSION}
Release:    %{RELEASE}
Group:      TEST
License:    Copyright Test Inc. 2022

BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:  %{ARCH}
AutoReqProv: no



%description
BUILD: test-client
Test client for testing

$Id$

%prep

%build

%install

# Install directories and files
install -d -m 775 %{buildroot}%{module_deploy_dir}
install -d -m 775 %{buildroot}%{cli_deploy_dir}

# service related scripts
install -m 775 %_sourcedir/scripts/test_client/__init__.py %{buildroot}%{module_deploy_dir}/__init__.py
install -m 775 %_sourcedir/scripts/test_client/test_client.py %{buildroot}%{module_deploy_dir}/test_client.py
install -m 775 %_sourcedir/scripts/test-client %{buildroot}%{cli_deploy_dir}/test-client
install -m 775 %_sourcedir/scripts/test %{buildroot}%{cli_deploy_dir}/test

%clean
rm -rf %{buildroot}

%files
%defattr(-,%{module_deploy_user},%{module_deploy_group})
%config(noreplace) %attr(0775,%{module_deploy_user},%{module_deploy_group}) %{module_deploy_dir}
%config(noreplace) %{module_deploy_dir}/__init__.py
%config(noreplace) %{module_deploy_dir}/test_client.py
%config(noreplace) %{cli_deploy_dir}/test-conjur
%config(noreplace) %{cli_deploy_dir}/test

%post
ln -s /apps/test/test-client /usr/local/bin/test-client
ln -s /apps/test/test /usr/local/bin/test

%preun

%postun
if [ $1 == 1 ];then
   echo "--------------------------"
   echo "RPM is getting upgraded"
   echo "--------------------------"
elif [ $1 == 0 ];then
   echo "--------------------------------------"
   echo "RPM is getting removed/uninstalled"
   rm -rf %{cli_deploy_dir}/test-client
   echo "--------------------------------------"
fi

%changelog
