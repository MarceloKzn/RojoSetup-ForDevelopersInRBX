--!strict

export type EconomyState = {
	gold: number,
	gem: number,
}

export type PlayerData = {
	userId: number,
	economy: EconomyState,
}
