pub mod actions {
    use core::dict::Felt252Dict;
    use binary_dojo_example::models::Position;
    use binary_dojo_example::models::Moves;
    use binary_dojo_example::models::Direction;
    use binary_dojo_example::models::Vec2;
    use starknet::ContractAddress;
    use core::nullable::NullableTrait;
    
    #[derive(Destruct)]
    pub struct WorldState {
        pub positions: Felt252Dict<Nullable<Position>>,
        pub moves: Felt252Dict<Nullable<Moves>>,
    }

    pub trait IActions {
        fn spawn(ref world: WorldState, player: ContractAddress);
        fn move(ref world: WorldState, player: ContractAddress, direction: Direction);
    }
    pub impl ActionsImpl of IActions {
        fn spawn(ref world: WorldState, player: ContractAddress) {
            let position = Position { player: player, vec: Vec2 { x: 0, y: 0, }, };
            world.positions.insert(1, NullableTrait::new(position));
            let moves = Moves {
                player: player, remaining: 0, last_direction: Direction::None, can_move: false,
            };
            world.moves.insert(1, NullableTrait::new(moves.into()));
        }
        fn move(ref world: WorldState, player: ContractAddress, direction: Direction) {
            let position = world.positions.get(player.into());
            let moves = world.moves.get(player.into());
            if moves.remaining == 0 || moves.last_direction == direction {
                return;
            }
            let mut new_position = position;
            world
                .positions
                .insert(
                    player.into(),
                    NullableTrait::new(
                        Position {
                            player: player,
                            vec: Vec2 {
                                x: new_position.vec.x
                                    + match direction {
                                        Direction::Left => 0,
                                        Direction::Right => 1,
                                        _ => 0,
                                    },
                                y: new_position.vec.y
                                    + match direction {
                                        Direction::Up => 1,
                                        Direction::Down => 0,
                                        _ => 0,
                                    },
                            },
                        }
                    )
                );
        }
    }
}
