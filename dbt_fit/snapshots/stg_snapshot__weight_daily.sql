{% snapshot stg_snapshot__weight_daily %}

{{
    config(
      target_schema='dbt_rl_snapshots',
      unique_key='record__ts',

      strategy='timestamp',
      updated_at='record__ts',
    )
}}

select
  *
from {{ source('raw', 'raw__weight_daily') }}

{% endsnapshot %}