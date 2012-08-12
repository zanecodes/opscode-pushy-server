
-type id() :: binary().
%% object ids are always 32 characters hex. This spec matches the
%% length, might be able to constrain further for range of elements.
-type object_id() :: <<_:256>>.

%% node heartbeat status
-type heartbeat_status() :: idle |
                            ready |
                            running |
                            restarting |
                            down.

%% job status
-type job_status() :: voting |
                      running |
                      finished.

-type job_node_status() :: undefined |
                           ready |
                           running |
                           finished. % DONE

%% random PoC hard-codings
-define(POC_ORG_ID, <<"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa">>).
-define(POC_ORG_NAME, <<"pushy">>).
-define(POC_ACTOR_ID, <<"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb">>).
-define(POC_HB_THRESHOLD, 3).

-record(pushy_node_status, {'org_id'::object_id(),              % organization guid
                            'node_name'::binary(),              % node name
                            'status'::heartbeat_status(),       % node status
                            'last_updated_by'::object_id(),     % authz guid of last actor to update
                            'created_at'::calendar:datetime(),  % time created at
                            'updated_at'::calendar:datetime()   % time updated at
                            }).

-record(pushy_job_node, {'job_id'::object_id(),              % guid for object (unique)
                         'org_id'::object_id(),              % organization guid
                         'node_name'::binary(),              % node name
                         'status'::job_node_status(),        % node's status in context of job
                         'finished_reason'::binary(),        % reason node is finished with job (success, nack, etc.)
                         'created_at'::calendar:datetime(),  % time created at
                         'updated_at'::calendar:datetime()   % time updated at
                         }).

-record(pushy_job, {'id'::object_id(),                  % guid for object (unique)
                    'org_id'::object_id(),              % organization guid
                    'command'::binary(),                % command to execute
                    'status'::job_status(),             % job status
                    'duration'::non_neg_integer(),      % max duration (in minutes) to allow execution
                    'job_nodes' ::[#pushy_job_node{}],
                    'last_updated_by'::object_id(),     % authz guid of last actor to update
                    'created_at'::calendar:datetime(),  % time created at
                    'updated_at'::calendar:datetime()  % time updated at
                    }).

-type pushy_object() :: #pushy_node_status{} | #pushy_job{}.
