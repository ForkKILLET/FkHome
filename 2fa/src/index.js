import fs from 'node:fs/promises'
import twoFactor from 'node-2fa'

const getSecretFromFile = async () => {
    try {
        const buf = await fs.readFile('./2fa.txt')
        return buf.toString()
    }
    catch {
        return
    }
}

const secret = process.env['SECRET_2FA']
    || await getSecretFromFile()

if (! secret) {
    console.error('Error: $SECRET_2FA not found')
    process.exit(1)
}

console.log('Token: %s', twoFactor.generateToken(secret).token)

