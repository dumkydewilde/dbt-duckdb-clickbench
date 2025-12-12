{{
    config(
        description="Table materialization for reference",
        materialized='table'
    )
}}

select * from {{ ref('stg_clickbench__hits') }}