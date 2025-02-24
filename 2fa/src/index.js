import fs from 'node:fs/promises'
import path from 'node:path'
import url from 'node:url'
import twoFactor from 'node-2fa'

const env = process.env['SECRET_2FA']
const nameArg = process.argv[2]
const name = nameArg || 'default'

if (env && nameArg) {
	console.error('Error: $SECRET_2FA and .2fa file cannot coexist.')
	process.exit(1)
}

const getSecret = async () => {
	if (env) return env

	try {
		const file = path.join(url.fileURLToPath(import.meta.url), `../../${name}.2fa`)
        return await fs.readFile(file, 'utf-8')
	}
    catch {}
}

const secret = (await getSecret()).trim()

if (! secret) {
    console.error('Error: 2FA secret not found. Set $SECRET_2FA or use a .2fa file.')
    process.exit(1)
}

const token = twoFactor.generateToken(secret).token 
console.log(`Token for ${ env ? '$SECRET_2FA' : `${name}.2fa` }: <${ token }>`)

