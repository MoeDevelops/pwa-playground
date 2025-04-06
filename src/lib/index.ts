import { toBuffer, toString } from "uuid-buffer"

export type User = {
  id: string
  username: string
}

export type BinUser = {
  id: Buffer
  username: string
}

export function binUserToUser(binUser: BinUser): User {
  return { ...binUser, id: toString(binUser.id) }
}

export function userToBinUser(user: User): BinUser {
  return { ...user, id: toBuffer(user.id) }
}

export type Chat = {
  id: string
  user1: string
  user2: string
}

export type Message = {
  id: string
  author: string
  authorName: string
  content: string
}
