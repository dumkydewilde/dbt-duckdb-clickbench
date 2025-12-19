with invocations_per_target as (
    select
        target_name,
        command_invocation_id,
        run_started_at,
        full_refresh_flag
    from {{ ref('dbt_artifacts', 'fct_dbt__invocations') }}
    where dbt_command = 'run'
    and target_name like 'incremental_%'
    and full_refresh_flag = false
),

latest_model_runs as (
    select 
        inv.target_name,
        inv.command_invocation_id,
        exec.name as model_name,
        exec.status as model_status,
        exec.message,
        inv.full_refresh_flag as full_refresh,
        exec.total_node_runtime as model_runtime_s,
        exec.run_started_at as run_started_at,
        row_number() over (partition by exec.name, inv.target_name order by exec.run_started_at desc) = 1 as is_latest

    from invocations_per_target as inv
    left join {{ ref('dbt_artifacts', 'fct_dbt__model_executions') }} as exec
        on inv.command_invocation_id = exec.command_invocation_id
)

select
    model_name,
    target_name,
    model_status,
    model_runtime_s,
    run_started_at
from latest_model_runs
where is_latest = true
order by model_status desc, model_runtime_s asc