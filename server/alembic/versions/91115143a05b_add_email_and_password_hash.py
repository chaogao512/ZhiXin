"""add email and password_hash

Revision ID: 91115143a05b
Revises: 753e76bd624d
Create Date: 2026-06-08 19:09:55.775448

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '91115143a05b'
down_revision: Union[str, Sequence[str], None] = '753e76bd624d'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column('users', sa.Column('email', sa.String(), nullable=True))
    op.add_column('users', sa.Column('password_hash', sa.String(), nullable=True))
    op.create_index('ix_users_email', 'users', ['email'], unique=True)


def downgrade() -> None:
    op.drop_index('ix_users_email', table_name='users')
    op.drop_column('users', 'password_hash')
    op.drop_column('users', 'email')
