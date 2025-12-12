with invocations_per_target as (
    select
        target_name,
        command_invocation_id,
        run_started_at,
        row_number() over (partition by target_name order by run_started_at desc) = 1 as is_latest
    from {{ ref('dbt_artifacts', 'fct_dbt__invocations') }}
    where dbt_command = 'run'
    and target_name like 'clickbench_%'
),

latest_model_runs as (
    select 
        inv.target_name,
        inv.command_invocation_id,
        sum(exec.total_node_runtime) as total_runtime_s,
        count(*) as models_executed,
        min(exec.run_started_at) as run_started_at,
        min(exec.run_started_at) + interval '1 second' * sum(exec.total_node_runtime) as run_completed_at
        
    from invocations_per_target as inv
    left join {{ ref('dbt_artifacts', 'fct_dbt__model_executions') }} as exec
        on inv.command_invocation_id = exec.command_invocation_id
    where inv.is_latest = true
    group by inv.target_name, inv.command_invocation_id
)

select
    target_name,
    total_runtime_s,
    models_executed,
    run_started_at

from latest_model_runs
order by total_runtime_s asc