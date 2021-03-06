##########################GO-LICENSE-START################################
# Copyright 2014 ThoughtWorks, Inc.
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
##########################GO-LICENSE-END##################################

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FailuresHelper do
  include FailuresHelper, RailsLocalizer

  describe :fbh_details_link do
    it "should ensure uniqueness" do
      job_id = JobIdentifier.new("pipeline-foo", 12, "label-1020", "stage-bar", "34", "build-dev")
      id = fbh_failure_detail_popup_id_for_failure(job_id, "my-suite", "his-test")
      id.should =~ /pipeline-foo/
      id.should =~ /12/
      id.should =~ /stage-bar/
      id.should =~ /34/
      id.should =~ /build-dev/
      id.should =~ /my-suite/
      id.should =~ /his-test/
    end

    it "should enforce uniqueness of suite_name test_name combination" do
      job_id = JobIdentifier.new("pipeline_foo", 12, "label-1020", "stage_bar", "34", "build_dev")
      fbh_failure_detail_popup_id_for_failure(job_id, "my", "suite_his_test").should_not == fbh_failure_detail_popup_id_for_failure(job_id, "my_suite", "his_test")
    end

    it "should escape single quotes" do
      job_id = JobIdentifier.new("p", 12, "l", "s", "34", "j")
      id = fbh_failure_detail_popup_id_for_failure(job_id, 'm"y', 'su\"ite_"his_test')
      id.should =~ /m\\"y/
      id.should =~ /su\\\\\\"ite/
    end

    it "should render anchor and js for failed_test details" do
      job_id = JobIdentifier.new("foo", 12, "label-1020", "bar", "34", "baz")
      failure_details_link(job_id, "suite", "test").should == <<VAR
<a href='#{failure_details_path(job_id, "suite", "test")}' id="for_fbh_failure_details_foo/12/bar/34/baz_suite_test" class="fbh_failure_detail_button" title='View failure details'>[Trace]</a>
VAR
    end
  end
end